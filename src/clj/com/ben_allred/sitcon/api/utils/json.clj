(ns com.ben-allred.sitcon.api.utils.json
  (:require [jsonista.core :as jsonista]
            [com.ben-allred.sitcon.api.utils.keywords :as keywords]
            [com.ben-allred.sitcon.api.utils.logging :as log]))

(def ^:private mapper
  (jsonista/object-mapper
    {:encode-key-fn keywords/safe-name
     :decode-key-fn keyword}))

(defn parse [s]
  (jsonista/read-value s mapper))

(defn stringify [o]
  (jsonista/write-value-as-string o))
