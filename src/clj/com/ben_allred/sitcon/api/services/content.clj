(ns com.ben-allred.sitcon.api.services.content
  (:require [com.ben-allred.sitcon.api.utils.maps :as maps]
            [com.ben-allred.sitcon.api.utils.json :as json]
            [com.ben-allred.sitcon.api.utils.logging :as log])
  (:import (java.io InputStream)))

(defn ^:private with-headers [request header-keys type]
  (update request :headers (partial merge (zipmap header-keys (repeat type)))))

(defn ^:private stream? [value]
  (instance? InputStream value))

(defn ^:private when-not-string [body f]
  (if (string? body)
    body
    (f body)))

(defn ^:private try-to [value f]
  (try (f value)
       (catch Throwable _
         nil)))

(def ^:private json?
  (comp (partial re-find #"application/json") str))

(defn parse [data content-type]
  (cond-> data
    (= "" (:body data)) (dissoc data :body)
    (json? content-type) (maps/update-maybe :body try-to json/parse)))

(defn prepare [data header-keys]
  (cond-> data
    (= "" (:body data)) (dissoc :body)
    :always (->
              (maps/update-maybe :body when-not-string json/stringify)
              (with-headers header-keys "application/json"))))
