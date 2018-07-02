(ns com.ben-allred.sitcon.api.routes.emoji
  (:require [compojure.core :refer [defroutes context GET]]
            [com.ben-allred.sitcon.api.utils.respond :as respond]
            [com.ben-allred.sitcon.api.services.db.models :as models]))

(defroutes emoji
  (GET "/emoji" []
    (respond/with [:status/ok {:emoji (models/select-emoji)}])))
