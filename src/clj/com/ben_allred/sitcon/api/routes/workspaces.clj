(ns com.ben-allred.sitcon.api.routes.workspaces
  (:require [compojure.core :refer [defroutes context GET POST]]
            [com.ben-allred.sitcon.api.utils.respond :as respond]
            [com.ben-allred.sitcon.api.services.db.models :as models]))

(defroutes workspaces
  (GET "/workspaces" {:keys [user]}
    (respond/with [:status/ok {:workspaces (models/select-workspaces-with-channels (:id user))}])))
