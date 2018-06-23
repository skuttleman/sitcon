(ns user
  (:require [com.ben-allred.sitcon.api.services.env :as env]))

(defn update-env [key val]
  (alter-var-root #'env/get assoc key val))
