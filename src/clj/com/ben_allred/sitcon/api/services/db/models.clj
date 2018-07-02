(ns com.ben-allred.sitcon.api.services.db.models
  (:require [com.ben-allred.sitcon.api.repositories.core :as repo]
            [com.ben-allred.sitcon.api.repositories.emoji :as repo.emoji]))

(defn select-emoji []
  (repo/exec! repo.emoji/all-emoji))
