(ns com.ben-allred.sitcon.api.utils.query-params
  (:require [com.ben-allred.sitcon.api.utils.keywords :as keywords]
            [clojure.string :as string]))

(defn ^:private namify [[k v]]
  [(str (keywords/safe-name k)) (str (keywords/safe-name v))])

(defn parse [s]
  (->> (string/split s #"&")
       (map #(string/split % #"="))
       (filter (comp seq first))
       (reduce (fn [qp [k v]] (assoc qp (keyword k) (or v true))) {})))

(defn stringify [qp]
  (->> qp
       (map namify)
       (map (partial string/join "="))
       (string/join "&")))
