(ns com.ben-allred.sitcon.api.routes.workspaces
  (:require [compojure.core :refer [defroutes context GET POST]]
            [com.ben-allred.sitcon.api.utils.respond :as respond]
            [com.ben-allred.sitcon.api.services.db.models :as models]))

(defroutes workspaces
  (context "/workspaces" {:keys [user]}
    (GET "/" []
      (respond/with [:status/ok {:workspaces (models/select-workspaces-with-channels (:id user))}]))
    (context "/:workspace" [workspace]
      (context "/channels" []
        (context "/:channel" [channel]
          (GET "/messages" []
            (respond/with [:status/ok {:entries (models/select-entries workspace channel)}])))))))
