object WebServerModule: TWebServerModule
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebServerModuleDefaultHandlerAction
    end>
  Height = 230
  Width = 415
end
