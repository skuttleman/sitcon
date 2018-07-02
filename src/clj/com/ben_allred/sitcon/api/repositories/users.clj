(ns com.ben-allred.sitcon.api.repositories.users
  (:require [com.ben-allred.sitcon.api.repositories.core :as repo]))

(defn select-users-for-workspace [workspace-id]
  (repo/single-simple {:select [:u.*]
                       :from   [[:user-workspaces :uw]]
                       :join   [[:users :u] [:= :u.id :uw.user-id]]
                       :where  [:= :uw.workspace-id workspace-id]}))
