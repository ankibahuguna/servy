defmodule Servy.Handler do 
  def handle(request) do
    request 
    |> parse 
    |> log
    |> route 
    |> format_response

  end

  def parse(request) do
    [method, path, _] = request 
                        |> String.split("\n") 
                        |> List.first 
                        |> String.split(" ")

     %{ method: method, path: path,  status: nil, resp_body: "" }
  end

  def log(conv), do: IO.inspect conv

  def route(conv) do 
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wildthings") do 
    %{ conv |  status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(conv, "GET", "/bears") do
    %{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
  end

  def route(conv, "GET", "/bears/" <> id) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(conv, _method, path) do 
    %{ conv |  status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(conv) do 
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

end
  request = """
  GET /wildthings HTTP/1.1
  Host: example.com
  User-Agent: ExampleBrowser/1.0
  Accept:*/*

  """

request2 = """
  GET /bears HTTP/1.1
  Host: example.com
  User-Agent: ExampleBrowser/1.0
  Accept:*/*

  """
request3 = """
  GET /bigfoot HTTP/1.1
  Host: example.com
  User-Agent: ExampleBrowser/1.0
  Accept:*/*

  """

request4 = """
  GET /bears/1 HTTP/1.1
  Host: example.com
  User-Agent: ExampleBrowser/1.0
  Accept:*/*

  """
  IO.puts Servy.Handler.handle(request)
  IO.puts Servy.Handler.handle(request2)
  IO.puts Servy.Handler.handle(request3)
  IO.puts Servy.Handler.handle(request4)