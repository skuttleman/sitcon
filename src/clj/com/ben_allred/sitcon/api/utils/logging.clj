(ns com.ben-allred.sitcon.api.utils.logging
  (:require [taoensso.timbre :as logger :include-macros true]
            [com.ben-allred.sitcon.api.utils.maps :as maps]
            [clojure.string :as string]
            [com.ben-allred.sitcon.api.utils.strings :as strings]
            [com.ben-allred.sitcon.api.utils.colors :as colors]
            [kvlt.core :refer [quiet!]]))

(defmacro debug [& args]
  `(logger/debug ~@args))

(defmacro info [& args]
  `(logger/info ~@args))

(defmacro warn [& args]
  `(logger/warn ~@args))

(defmacro error [& args]
  `(logger/error ~@args))

(defmacro spy* [expr result f spacer]
  `(let [result# ~result]
     (warn ~expr ~spacer (colors/colorize (~f result#)))
     result#))

(defmacro spy-tap [f expr]
  `(spy* (quote ~expr) ~expr ~f "\uD83C\uDF7A "))

(defmacro spy-on [f]
  `(fn [& args#]
     (spy* (cons (quote ~f) args#) (apply ~f args#) identity "\u27A1 ")))

(defmacro spy [expr]
  `(spy* (quote ~expr) ~expr identity "\uD83D\uDC40 "))

(defmacro tap-spy [expr f]
  `(spy* (quote ~expr) ~expr ~f "\uD83C\uDF7A "))

(defn ^:private ns-color [ns-str]
  (colors/with-style ns-str {:color :blue :trim? true}))

(defn ^:private level-color [level]
  (->> (case level
         :debug :cyan
         :warn :yellow
         :error :red
         :white)
       (assoc {:attribute :invert :trim? true} :color)
       (colors/with-style (str "[" (string/upper-case (name level)) "]"))))

(defn ^:private no-color [arg]
  (if-not (colors/colorized? arg)
    (colors/with-style arg {})
    arg))

(defn ^:private formatter [{:keys [env level ?ns-str] :as data}]
  (update data :vargs (fn [vargs]
                        (conj (seq vargs)
                              (level-color level)
                              (ns-color (or ?ns-str "ns?"))))))

(quiet!)

(logger/merge-config!
  {:level      :debug
   :middleware [formatter]
   :appenders  {:println    {:enabled? false}
                :console    {:enabled? false}
                :system-out {:enabled? true
                             :fn       #(.println System/out @(:msg_ %))}}})
