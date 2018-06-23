(ns com.ben-allred.sitcon.api.server
  (:gen-class)
  (:use compojure.core)
  (:require [clojure.tools.nrepl.server :as nrepl]
            [com.ben-allred.sitcon.api.routes.auth :as auth]
            [com.ben-allred.sitcon.api.routes.user :as user]
            [com.ben-allred.sitcon.api.services.middleware :as middleware]
            [com.ben-allred.sitcon.api.utils.respond :as respond]
            [com.ben-allred.sitcon.api.services.env :as env]
            [com.ben-allred.sitcon.api.utils.logging :as log]
            [compojure.handler :refer [site]]
            [compojure.route :as route]
            [immutant.web :as web]
            [ring.middleware.reload :refer [wrap-reload]]
            [ring.util.response :as response]))

(defn ^:private not-found
  ([] (not-found nil))
  ([message]
   (respond/with [:status/not-found (when message {:message message})])))

(defroutes ^:private base
  #_(context "/auth" []
    auth/auth)
  (context "/api" []
    (GET "/health" [] (respond/with [:status/ok {:a :ok}]))
    #_(ANY "/*" {:keys [user]} (when-not user (respond/with [:status/unauthorized])))
    #_user/user)
  (context "/" []
    (route/resources "/")
    (GET "/*" [] (response/resource-response "index.html" {:root "public"}))
    (ANY "/*" [] (not-found))))

(def ^:private app
  (-> #'base
      (middleware/auth)
      (site)
      (middleware/content-type)
      (middleware/log-response)))

(defn ^:private server-port [env key fallback]
  (let [port (str (or (get env key) (env/get key) fallback))]
    (Integer/parseInt port)))

(defn ^:private run [app env]
  (let [port (server-port env :port 3000)
        server (web/run app {:port port})]
    (println "Server is listening on port" port)
    server))

(def ^:private -dev-server nil)

(def ^:private -dev-repl-server nil)

(defn -main [& {:as env}]
  [(partial web/stop (run app env))])

(defn -dev [& {:as env}]
  (let [server (run #'app env)
        nrepl-port (server-port env :nrepl-port 7000)
        repl-server (nrepl/start-server :port nrepl-port)]
    (println "Server is running with #'wrap-reload")
    (println "REPL is listening on port" nrepl-port)
    (alter-var-root #'-dev-server (constantly server))
    (alter-var-root #'-dev-repl-server (constantly repl-server))
    [(partial web/stop server) (partial nrepl/stop-server repl-server)]))
