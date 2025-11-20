package openapi

import ("net/http";"testing")

func TestAPI_Health(t *testing.T){resp,err:=http.Get("http://localhost:8080/api/time");if err!=nil{t.Fatalf("err: %v",err)};if resp.StatusCode!=200{t.Fatalf("bad code: %d",resp.StatusCode)}}
