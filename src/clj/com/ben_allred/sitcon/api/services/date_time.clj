(ns com.ben-allred.sitcon.api.services.date-time
  (:require [clj-time.local :as ct.local]))

(defn now []
  (ct.local/local-now))

(defn to-str [dt format]
  (ct.local/format-local-time
    dt
    format))

(defn to-date [s]
  (ct.local/to-local-date-time s))
