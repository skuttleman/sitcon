(ns com.ben-allred.sitcon.api.utils.preds
  (:import (java.util.regex Pattern)))

(defn regexp? [value]
  (instance? Pattern value))
