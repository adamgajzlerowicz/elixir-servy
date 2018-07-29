defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def log(data), do: IO.inspect data

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{
      method: method,
      path: path,
      resp_body: "",
      status: nil
    }
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason conv.status}
    Content-Type: text/html
    Content-Length: #{String.length conv.resp_body}

    #{conv.resp_body}
    """
  end

  def route(conv) do
    route(conv, conv.method, conv.path)
  end


  def route(conv, "GET", "/wildthings") do
    %{ conv | resp_body: "Bears, Lions, Tigers", status: 200 }
  end

  def route(conv, "GET", "/bears") do
    %{ conv | resp_body: "Teddy, Smokey, Paddington", status: 200 }
  end

  def route(conv, "GET", "/bears/" <> id) do
    %{ conv | resp_body: "Bear #{id}", status: 200 }
  end

  def route(conv, _method, path) do
    %{ conv | resp_body: "No path #{path} found", status: 404 }
  end

  defp status_reason(status) do
    %{
      200 => :OK,
      404 => :Dupa
    }[status]
  end

end



request = """
GET /bears/3 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""


IO.puts(Servy.Handler.handle(request))

# request = """
# GET /wildthings HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# """


# IO.puts(Servy.Handler.handle(request))

# request = """
# GET /bears HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# """


# IO.puts(Servy.Handler.handle(request))

# request = """
# GET /dupa HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# """

# IO.puts(Servy.Handler.handle(request));
