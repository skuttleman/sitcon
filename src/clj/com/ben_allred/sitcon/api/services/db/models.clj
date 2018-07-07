(ns com.ben-allred.sitcon.api.services.db.models
  (:require [com.ben-allred.sitcon.api.repositories.core :as repo]
            [com.ben-allred.sitcon.api.repositories.emoji :as repo.emoji]
            [com.ben-allred.sitcon.api.repositories.entries :as repo.entries]
            [com.ben-allred.sitcon.api.repositories.workspaces :as repo.workspaces]
            [com.ben-allred.sitcon.api.repositories.users :as repo.users]
            [clojure.set :as set]
            [com.ben-allred.sitcon.api.utils.logging :as log]))

(defn ^:private roll [group-fn nest-key keys-to-roll items]
  (->> items
       (group-by group-fn)
       (map (fn [[_ [item :as items]]]
              (-> (apply dissoc item keys-to-roll)
                  (assoc nest-key (map #(select-keys % keys-to-roll) items)))))))

(defn ^:private nest [root-key items]
  (let [root-key' (name root-key)]
    (->> items
         (map (fn [item]
                (let [groups (group-by (comp namespace first) item)
                      others (dissoc groups nil root-key')
                      init (into {} (concat (get groups nil) (get groups root-key')))]
                  (->> others
                       (reduce (fn [m [k v]] (assoc m k (into {} v))) init))))))))

(defn select-emoji []
  (-> [repo.emoji/all-emoji
       (partial roll :id :handles #{:handle})]
      (repo/single)
      (repo/exec!)))

(defn select-workspaces [user-id]
  (-> user-id
      (repo.workspaces/select-for-user)
      (repo/single-simple)
      (repo/exec!)))

(defn select-workspaces-with-channels [user-id]
  (-> [(-> user-id
           (repo.workspaces/select-for-user)
           (repo.workspaces/with-channels))
       (comp
         (partial map #(set/rename-keys % {:workspace-id :id}))
         (partial roll :w/id :channels #{:c/id :c/handle :c/private :c/purpose :c/workspace_id}))]
      (repo/single)
      (repo/exec!)))

(defn select-user-by-email [email]
  (-> [(repo.users/find-by-email email) first]
      (repo/single)
      (repo/exec!)))

(defn select-entries [workspace channel]
  (-> [(-> (repo.entries/find-by-workspace-and-channel workspace channel)
           (repo.entries/with-creator)
           (repo.entries/with-message))
       (partial nest :e)]
      (repo/single)
      (repo/exec!)))
