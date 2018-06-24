(ns com.ben-allred.sitcon.api.services.middleware
  (:require [com.ben-allred.sitcon.api.utils.logging :as log]
            [com.ben-allred.sitcon.api.services.jwt :as jwt]
            [clojure.string :as string]
            [com.ben-allred.sitcon.api.services.content :as content]
            [com.ben-allred.sitcon.api.utils.uuids :as uuids]
            [com.ben-allred.sitcon.api.utils.maps :as maps])
  (:import [java.util Date]))

(defn ^:private api? [{:keys [uri websocket?]}]
  (and (not websocket?)
       (re-find #"^/api" uri)))

(defn log-response [handler]
  (fn [request]
    (let [start (Date.)
          response (handler request)
          end (Date.)
          uri (:uri request)]
      (when (api? request)
        (log/info (format "[%d](%dms) %s: %s"
                          (or (:status response) 404)
                          (- (.getTime end) (.getTime start))
                          (string/upper-case (name (:request-method request)))
                          uri)))
      response)))

(defn content-type [handler]
  (fn [{:keys [headers] :as request}]
    (cond-> request
      :always (content/parse (get headers "content-type"))
      :always (handler)
      (api? request) (content/prepare #{"content-type" "accept"}))))

(defn auth [handler]
  (fn [request]
    (let [user (some-> request
                       (:cookies)
                       (get "auth-token")
                       (:value)
                       (jwt/decode)
                       (:data)
                       (maps/update-maybe :id uuids/->uuid))]
      (cond-> request
        user (assoc :user user)
        :always (handler)))))
