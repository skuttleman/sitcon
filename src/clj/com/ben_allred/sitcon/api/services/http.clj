(ns com.ben-allred.sitcon.api.services.http
  (:refer-clojure :exclude [get])
  (:require [clojure.core.async :as async]
            [kvlt.chan :as kvlt]
            [com.ben-allred.sitcon.api.services.content :as content]
            [com.ben-allred.sitcon.api.utils.logging :as log]))

(def ^:private header-keys #{:content-type :accept})

(defn ^:private content-type-header [{:keys [headers]}]
  (clojure.core/get headers "content-type" (:content-type headers)))

(def status->kw
  {200 :status/ok
   201 :status/created
   202 :status/accepted
   203 :status/non-authoritative-information
   204 :status/no-content
   205 :status/reset-content
   206 :status/partial-content
   300 :status/multiple-choices
   301 :status/moved-permanently
   302 :status/found
   303 :status/see-other
   304 :status/not-modified
   305 :status/use-proxy
   306 :status/unused
   307 :status/temporary-redirect
   400 :status/bad-request
   401 :status/unauthorized
   402 :status/payment-required
   403 :status/forbidden
   404 :status/not-found
   405 :status/method-not-allowed
   406 :status/not-acceptable
   407 :status/proxy-authentication-required
   408 :status/request-timeout
   409 :status/conflict
   410 :status/gone
   411 :status/length-required
   412 :status/precondition-failed
   413 :status/request-entity-too-large
   414 :status/request-uri-too-long
   415 :status/unsupported-media-type
   416 :status/requested-range-not-satisfiable
   417 :status/expectation-failed
   500 :status/internal-server-error
   501 :status/not-implemented
   502 :status/bad-gateway
   503 :status/service-unavailable
   504 :status/gateway-timeout
   505 :status/http-version-not-supported})

(def kw->status
  (into {} (map (comp vec reverse)) status->kw))

(defn ^:private check-status [lower upper response]
  (when-let [status (if (vector? response)
                      (kw->status (clojure.core/get response 2))
                      (:status response))]
    (<= lower status upper)))

(def success?
  (partial check-status 200 299))

(def client-error?
  (partial check-status 400 499))

(def server-error?
  (partial check-status 500 599))

(defn request* [method url request]
  (async/go
    (let [headers (merge {:content-type "application/json" :accept "application/json"}
                         (:headers request))
          ch-response (async/<! (-> request
                                    (assoc :method method :url url)
                                    (content/prepare header-keys)
                                    (update :headers merge headers)
                                    (kvlt/request!)))
          {:keys [status] :as response} (if-let [data (ex-data ch-response)]
                                          data
                                          ch-response)
          body (-> response
                   (content/parse (content-type-header response))
                   (:body))
          status (status->kw status status)]
      (if (success? response)
        [:success body status response]
        [:error body status response]))))

(defn get [url & [request]]
  (request* :get url request))

(defn post [url request]
  (request* :post url request))

(defn patch [url request]
  (request* :patch url request))

(defn put [url request]
  (request* :put url request))

(defn delete [url & [request]]
  (request* :delete url request))
