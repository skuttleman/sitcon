(ns com.ben-allred.sitcon.api.routes.user
  (:require [compojure.core :refer [defroutes context GET POST]]
            [com.ben-allred.sitcon.api.utils.respond :as respond]))

(defroutes user
  (GET "/user/details" {:keys [user]}
    (respond/with [:status/ok {:user user}])))
