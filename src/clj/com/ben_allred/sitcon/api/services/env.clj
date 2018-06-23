(ns com.ben-allred.sitcon.api.services.env
  (:refer-clojure :exclude [get])
  (:require [environ.core :as environ]))

(def get environ/env)

(def dev?
  (not= "production" (get :ring-env)))
