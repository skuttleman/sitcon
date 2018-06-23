(ns com.ben-allred.sitcon.api.services.emitter
  (:require [clojure.core.async :as async]
            [clojure.core.async.impl.protocols :as impl]
            [com.ben-allred.sitcon.api.utils.logging :as log]))

(defprotocol IEmitter
  (on [this chan] [this event chan])
  (publish [this event data]))

(defn new []
  (let [listeners (atom {})]
    (reify IEmitter
      (on [this chan]
        (on this ::all chan))
      (on [this event chan]
        (swap! listeners update event conj chan)
        this)
      (publish [this event data]
        (when-let [chans (-> listeners
                             (swap! update event (partial remove impl/closed?))
                             (select-keys [::all event])
                             (#(mapcat val %))
                             (seq))]
          (->> chans
               (map #(async/put! % [event data]))
               (dorun)))
        this))))
