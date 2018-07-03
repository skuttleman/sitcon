(ns com.ben-allred.sitcon.api.services.db.models
  (:require [com.ben-allred.sitcon.api.repositories.core :as repo]
            [com.ben-allred.sitcon.api.repositories.emoji :as repo.emoji]
            [com.ben-allred.sitcon.api.repositories.workspaces :as repo.workspaces]
            [com.ben-allred.sitcon.api.repositories.users :as repo.users]
            [clojure.set :as set]))

(defn ^:private roll [group-fn nest-key keys-to-roll items]
  (->> items
       (group-by group-fn)
       (map (fn [[_ [item :as items]]]
              (-> (apply dissoc item keys-to-roll)
                  (assoc nest-key (map #(select-keys % keys-to-roll) items)))))))

(defn select-emoji []
  (repo/exec! (repo/single [repo.emoji/all-emoji
                            (partial roll :id :handles #{:handle})])))

(defn select-workspaces [user-id]
  (repo/exec! (repo/single-simple (repo.workspaces/select-for-user user-id))))

(defn select-workspaces-with-channels [user-id]
  (repo/exec! (repo/single [(-> user-id
                                (repo.workspaces/select-for-user)
                                (repo.workspaces/with-channels))
                            (comp
                              (partial map #(set/rename-keys % {:workspace-id :id}))
                              (partial roll :w/id :channels #{:c/id :c/handle :c/private :c/purpose :c/workspace_id}))])))

(defn select-user-by-email [email]
  (repo/exec! (repo/single [(repo.users/find-by-email email) first])))
