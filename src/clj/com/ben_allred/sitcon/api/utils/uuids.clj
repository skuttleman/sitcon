(ns com.ben-allred.sitcon.api.utils.uuids
  (:import (java.util UUID)))

(defn ->uuid [v]
  (when v
    (if (uuid? v)
      v
      (UUID/fromString v))))

(defn random []
  (UUID/randomUUID))
