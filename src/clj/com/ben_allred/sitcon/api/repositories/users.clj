(ns com.ben-allred.sitcon.api.repositories.users
  (:require [com.ben-allred.sitcon.api.services.db.entities :as entities]))

(defn select-for-workspace [workspace-id]
  (-> entities/users
      (entities/with-alias :u)
      (assoc :from [[:user-workspaces :uw]]
             :join [[:users :u] [:= :u.id :uw.user-id]]
             :where [:= :uw.workspace-id workspace-id])))

(defn find-by-email [email]
  (-> entities/users
      (entities/with-alias :u)
      (assoc :where [:= :u.email email])))
