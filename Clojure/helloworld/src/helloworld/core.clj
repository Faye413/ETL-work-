(ns helloworld.core)
(require '[semantic-csv.core :refer :all]
         '[clojure-csv.core :as csv]
         '[clojure.java.io :as io]
         '[clojure.java.jdbc :as sql])

(defn open-csv-file
	[fname]
	(with-open [f (io/reader fname)]
	(println
		(csv/parse-csv f)
		mappify
		doall)))

(def db {:subprotocol "postgresql"
         :subname "//localhost:5432/clojure"
         :user "faye.zhang"})

(defn -main []
  "I can say 'Hello World'."
  (println "hi")
  (open-csv-file "in-file.csv")
)


