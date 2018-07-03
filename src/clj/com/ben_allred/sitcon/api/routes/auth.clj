(ns com.ben-allred.sitcon.api.routes.auth
  (:require [compojure.core :refer [defroutes context GET POST]]
            [ring.util.response :as resp]
            [com.ben-allred.sitcon.api.services.jwt :as jwt]
            [com.ben-allred.sitcon.api.services.env :as env]
            [com.ben-allred.sitcon.api.utils.logging :as log]
            [com.ben-allred.sitcon.api.services.db.models :as models]))

(defn ^:private token->cookie [resp cookie value]
  (->> value
       (assoc {:path "/" :http-only true} :value)
       (merge cookie)
       (assoc-in resp [:cookies "auth-token"])))

(defn ^:private redirect [cookie value]
  (-> (str (env/get :base-url) "/")
      (resp/redirect)
      (token->cookie cookie value)))

(defn ^:private logout []
  (redirect {:max-age 0} ""))

(defn ^:private login [user]
  (if (seq user)
    (redirect nil (jwt/encode user))
    (logout)))

(defroutes auth
  (GET "/login" {:keys [params]}
    (-> params
        (:email)
        (models/select-user-by-email)
        (login)))
  (GET "/logout" [] (logout)))
