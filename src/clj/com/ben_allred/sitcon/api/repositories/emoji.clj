(ns com.ben-allred.sitcon.api.repositories.emoji
  (:require [com.ben-allred.sitcon.api.repositories.core :as repo]))

(defn ^:private nest-emoji [emoji]
  (->> emoji
       (group-by #(select-keys % [:id :utf_string]))
       (map (fn [[emoji handles]]
              (assoc emoji :handles (map :handle handles))))))

(def all-emoji
  (repo/single [{:select [:e.id :e.utf_string :ea.handle]
                 :from   [[:emoji :e]]
                 :join   [[:emoji-aliases :ea] [:= :ea.emoji-id :e.id]]}
                nest-emoji]))
