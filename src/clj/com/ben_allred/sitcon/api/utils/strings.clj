(ns com.ben-allred.sitcon.api.utils.strings
  (:require [clojure.string :as string]))

(defn trim-to-nil [s]
  (when-let [s (and s (string/trim s))]
    (when-not (empty? s)
      s)))

(defn maybe-pr-str [s]
  (cond-> s
    (not (string? s)) (pr-str)))

(def ^:private ->kebab*
  (comp (partial str "-") string/lower-case last first))

(defn ->kebab [s]
  (str (-> s (subs 0 1) (string/lower-case))
       (-> s (subs 1) (string/replace #"((_|-)[A-Za-z]|[A-Z])" ->kebab*))))
