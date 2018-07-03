(ns com.ben-allred.sitcon.api.repositories.emoji)

(def all-emoji
  {:select [:e.id :e.utf_string :ea.handle]
   :from   [[:emoji :e]]
   :join   [[:emoji-aliases :ea] [:= :ea.emoji-id :e.id]]})
