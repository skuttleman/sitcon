(ns com.ben-allred.sitcon.api.services.db.entities)

(defn ^:private with-field-alias [fields alias]
  (let [alias' (name alias)]
    (map (fn [field]
           (let [field' (name field)]
             [(keyword (str alias' "." field'))
              (keyword alias' field')]))
         fields)))

(def users
  {:fields #{:id :first-name :last-name :handle :email :avatar-url :external-id}
   :table :users})

(def workspaces
  {:fields #{:id :handle :description}
   :table  :workspaces})

(def channels
  {:fields #{:id :workspace-id :handle :purpose :private}
   :table  :channels})

(defn with-alias [{:keys [fields table]} alias]
  {:select (with-field-alias fields alias)
   :from   [[table alias]]})
