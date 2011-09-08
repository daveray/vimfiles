(ns vim.core)

(defn async* [f] 
  (future 
    (let [result (with-out-str 
                   (try 
                    (println (f))
                   (catch Exception e 
                     (.printStackTrace e 
                                       (java.io.PrintWriter. *out*))))) ]
      (javax.swing.SwingUtilities/invokeLater
      (fn []
        (doto (javax.swing.JDialog.)
          (.setTitle "Vim Async Result")
          (.setContentPane
            (javax.swing.JScrollPane.
              (doto (javax.swing.JTextArea.)
                (.setText result))))
          (.setSize 640 480)
          (.setModal true)
          (.setVisible true)))))))

(defmacro async [& body]
  `(async* (fn [] ~@body)))


