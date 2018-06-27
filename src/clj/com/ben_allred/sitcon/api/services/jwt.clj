(ns com.ben-allred.sitcon.api.services.jwt
  (:require [com.ben-allred.sitcon.api.services.env :as env]
            [clj-jwt.core :as clj-jwt]
            [clj-time.core :as time]
            [com.ben-allred.sitcon.api.utils.maps :as maps]))


(def ^:private jwt-secret (env/get :jwt-secret))

(defn valid? [token]
  (try
    (clj-jwt/verify (clj-jwt/str->jwt token) jwt-secret)
    (catch Throwable e
      false)))

(defn decode [jwt]
  (when (valid? jwt)
    (:claims (clj-jwt/str->jwt jwt))))

(defn encode
  ([payload] (encode payload 30))
  ([payload days-to-expire]
   (let [now (time/now)]
     (-> {:iat  now
          :data (maps/update-all payload #(if (uuid? %) (str %) %))
          :exp  (time/plus now (time/days days-to-expire))}
         (clj-jwt/jwt)
         (clj-jwt/sign :HS256 jwt-secret)
         (clj-jwt/to-str)))))
