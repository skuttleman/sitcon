(ns com.ben-allred.sitcon.api.services.db.entities)

(defn ^:private with-field-alias [fields alias]
  (let [alias' (name alias)]
    (map (fn [field]
           (let [field' (name field)]
             [(keyword (str alias' "." field'))
              (keyword alias' field')]))
         fields)))

(defn ^:private join-aliased* [query join-type entity alias on]
  (let [{select :select [from] :from} (with-alias entity alias)]
    (-> query
        (update :select concat select)
        (update join-type concat [from on]))))

(def users
  {:fields #{:id :first-name :last-name :handle :email :avatar-url :external-id}
   :table :users})

(def workspaces
  {:fields #{:id :handle :description}
   :table  :workspaces})

(def channels
  {:fields #{:id :workspace-id :handle :purpose :private}
   :table  :channels})

(def entries
  {:fields #{:id :channel-id :conversation-id :parent-entry-id :created-at :created-by}
   :table :entries})

(def messages
  {:fields #{:id :entry-id :body :created-at :created-by}
   :table :messages})

(defn with-alias [{:keys [fields table]} alias]
  {:select (with-field-alias fields alias)
   :from   [[table alias]]})

(defn join-aliased [query entity alias on]
  (join-aliased* query :join entity alias on))

(defn left-join-aliased [query entity alias on]
  (join-aliased* query :join entity alias on))
