(ns com.ben-allred.sitcon.api.repositories.workspaces
  (:require [com.ben-allred.sitcon.api.services.db.entities :as entities]))

(defn select-for-user [user-id]
  (-> entities/workspaces
      (entities/with-alias :w)
      (assoc :from [[:user-workspaces :uw]]
             :join [[:workspaces :w] [:= :w.id :uw.workspace-id]]
             :where [:= :uw.user-id user-id])))

(defn with-channels [query]
  (let [{:keys [select from]} (entities/with-alias entities/channels :c)]
    (-> query
        (update :join concat [(first from) [:= :c.workspace-id :w.id]])
        (update :select concat select))))
