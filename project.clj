(defproject com.ben-allred/sitcon "0.1.0-SNAPSHOT"
  :description "Situation Conversation"
  :license {:name "Eclipse Public License"
            :url  "http://www.eclipse.org/legal/epl-v10.html"}
  :main "com.ben-allred.sitcon.api.server/main"
  :aot [com.ben-allred.sitcon.api.server]
  :min-lein-version "2.6.1"

  :dependencies [
                 [clj-jwt "0.1.1"]
                 [clj-time "0.6.0"]
                 [clojure.jdbc/clojure.jdbc-c3p0 "0.3.3"]
                 [c3p0/c3p0 "0.9.1.2"]

                 [com.ben-allred/collaj "0.8.0"]
                 [com.ben-allred/formation "0.4.1"]

                 [com.taoensso/timbre "4.10.0"]
                 [compojure "1.6.0"]
                 [environ "1.1.0"]
                 [hawk "0.2.11"]
                 [honeysql "0.9.2"]
                 [io.nervous/kvlt "0.1.4"]
                 [metosin/jsonista "0.1.1"]
                 [mysql/mysql-connector-java "8.0.11"]
                 [org.clojure/clojure "1.9.0"]
                 [org.clojure/core.async "0.3.465"]
                 [org.clojure/data.json "0.2.6"]
                 [org.clojure/java.jdbc "0.7.7"]
                 [org.clojure/tools.nrepl "0.2.12"]
                 [org.immutant/immutant "2.1.10"]
                 [org.postgresql/postgresql "9.4-1206-jdbc41"]
                 [ragtime "0.7.2"]
                 [ring/ring-core "1.3.2"]
                 [ring/ring-defaults "0.2.1"]
                 [ring/ring-devel "1.6.3"]
                 [ring/ring-json "0.3.1"]
                 [stylefruits/gniazdo "1.0.1"]]

  :plugins [[lein-cooper "1.2.2"]
            [lein-sass "0.5.0"]
            [lein-shell "0.5.0"]]

  :jar-name "sitcon.jar"
  :uberjar-name "sitcon-standalone.jar"
  :source-paths ["src/clj"]

  :aliases {"migrations" ["run" "-m" "com.ben-allred.sitcon.api.services.db.migrations/run"]}

  :sass {:src              "src/scss"
         :output-directory "resources/public/css/"}

  :cooper {"sass"    ["lein" "sass" "auto"]
           "server"  ["lein" "run"]
           "webpack" ["npm" "start"]
           "reload" ["npm" "run" "reload"]}

  :profiles {:dev     {:dependencies  []
                       :main          "com.ben-allred.sitcon.api.server/-dev"
                       :source-paths  ["src/clj" "dev"]
                       :plugins       []
                       :clean-targets ^{:protect false :replace true} ["resources/public/js"
                                                                       "resources/public/css"
                                                                       :target-path]
                       :repl-options  {:nrepl-middleware [cemerick.piggieback/wrap-cljs-repl]}}
             :uberjar {:clean-targets ^{:protect false :replace true} ["resources/public/js"
                                                                       "resources/public/css"
                                                                       :target-path]
                       :sass          {:style :compressed}
                       :prep-tasks    ["compile" ["shell" "npm" "run" "build"] ["sass" "once"]]}})
