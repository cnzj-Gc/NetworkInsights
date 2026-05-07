Feature: CAMARA Network Traffic Analysis API vwip - Operation getTrafficAnalysis

    # Get the results of network analysis

    # Input to be provided by the implementation to the tester

	# Implementation indications:
	# * apiRoot: API root of the server URL

    # * Min start and end dates allowed
    # * Max requested time period allowed

    # References to OAS spec schemas refer to schemas specifies in network-traffic-analysis.yaml, version vwip

  Background: Common getTrafficAnalysis setup
    Given an environment at "apiRoot"
    And the resource "/network-traffic-analysis/vwip/traffic-analysis"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the "networkId" parameter is set by default to a valid network id
    And the "timePeriod" parameter is set as the time period over which the API consumer wants the traffic analysis to be done, including the start time and the end time.
    And the "frequency" parameter is set to a valid value: DAY or HOUR.

# Success scenarios

  @network_traffic_analysis_getTrafficAnalysis_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    Given networkId, startDate, endDate, period
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator
    And the response body complies to the OAS schema at "/components/schemas/TrafficAnalysisResponse"

  @network_traffic_analysis_getTrafficAnalysis_02_invalid_argument_scenario
  Scenario: Error response for invalid argument in request body
    Given the request body property argument is invalid, such as illegal character and format error
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" is "Client specified an invalid argument, request body or query param."

  @network_traffic_analysis_getTrafficAnalysis_03_out_of_range_scenario
  Scenario: Error responses where the parameters in the request body are out of range
    Given the request body property argument are out of range, for example the end time before start time
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" is "Client specified an invalid range."

  @network_traffic_analysis_getTrafficAnalysis_04_missing_authorization_scenario
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    And the request body is set to a valid request body
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @network_traffic_analysis_getTrafficAnalysis_05_missing_access_token_scope_scenario
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope network-traffic-analysis:traffic-analysis:read
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @network_traffic_analysis_getTrafficAnalysis_06_not_found_scenario
  Scenario: Not found
    Given parameters in the correct format, but the network id cannot be found
    When the request "getTrafficAnalysis" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
