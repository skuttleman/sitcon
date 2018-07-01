(ns com.ben-allred.sitcon.api.services.db.migrations
  (:require [ragtime.jdbc :as rag-db]
            [ragtime.repl :as rag]
            [com.ben-allred.sitcon.api.services.env :as env]
            [clojure.string :as string]
            [com.ben-allred.sitcon.api.services.date-time :as dt]))

(defn ^:private date-str []
  (-> (dt/now)
      (dt/to-str :mysql)
      (string/replace #"-|:" "")
      (string/replace #"\s" "_")))

(def ^:private db-spec {:classname "com.postgres.Driver"
                        :subprotocol "postgres"
                        :subname (format "//%s:%s/%s"
                                         (env/get :db-host)
                                         (env/get :db-port)
                                         (env/get :db-name))
                        :user (env/get :db-user)
                        :password (env/get :db-password)})

(defn load-config []
  {:datastore  (rag-db/sql-database db-spec)
   :migrations (rag-db/load-resources "migrations")})

(defn migrate! []
  (rag/migrate (load-config)))

(defn rollback! []
  (rag/rollback (load-config)))

(defn create! [name]
  (let [migration-name (format "%s_%s"
                               (date-str)
                               (-> name
                                   (string/replace #"-" "_")
                                   (string/lower-case)))]
    (spit (format "resources/migrations/%s.up.sql" migration-name) "\n")
    (spit (format "resources/migrations/%s.down.sql" migration-name) "\n")
    (println "created migration: " migration-name)))

(defn ^:export run [command & args]
  (case command
    "migrate" (migrate!)
    "rollback" (rollback!)
    "speedbump" (do (migrate!) (rollback!) (migrate!))
    "redo" (do (rollback!) (migrate!))
    "create" (create! (string/join "_" args))
    (throw (ex-info (str "unknown command: " command) {:command command :args args}))))
