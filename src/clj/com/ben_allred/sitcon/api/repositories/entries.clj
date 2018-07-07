(ns com.ben-allred.sitcon.api.repositories.entries
  (:require [com.ben-allred.sitcon.api.services.db.entities :as entities]))


(defn find-by-workspace-and-channel [workspace channel]
  (-> entities/entries
      (entities/with-alias :e)
      (assoc :join [[:channels :c] [:= :c.id :e.channel-id]
                    [:workspaces :w] [:= :w.id :c.workspace-id]]
             :where [:and [:= :w.handle workspace] [:= :c.handle channel]])))

(defn with-creator [query]
  (-> query
      (entities/join-aliased entities/users :creator [:= :creator.id :e.created-by])))

(defn with-message [query]
  (-> query
      (entities/left-join-aliased entities/messages :message [:= :message.entry-id :e.id])))
