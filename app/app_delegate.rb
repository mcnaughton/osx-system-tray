class AppDelegate
  attr_accessor :status_menu

  def applicationDidFinishLaunching(notification)

    @workspace = NSWorkspace.sharedWorkspace

    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']

    @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init

    img = NSImage.imageNamed("logo.png")
    img.size = [NSStatusBar.systemStatusBar.thickness, NSStatusBar.systemStatusBar.thickness]
    @status_item.setImage img
    @status_item.highlightMode = false

    refreshFeed { |items| refreshMenu(items) }
    @timer = BW::Reactor.add_periodic_timer 300.0 do
       refreshFeed { |items| refreshMenu(items) }
    end

  end

  def doQuit
    EM.cancel_timer(@timer)
    terminate
  end

  def goToHomepage

  end

  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end

  def refreshItems


  end
  def refreshFeed(&callback)
    @feedCallback = callback
    @feedItems = []
    feed_parser = BW::RSSParser.new("https://beta.dailyrepublic.com/feed/")
    feed_parser.delegate = self
    feed_parser.parse do |item|
      @feedItems << item
    end
  end

  def refreshMenu(items)
    @status_menu = NSMenu.new
    items.each {
      |item| NSLog("%@", item.title)
      @status_menu.addItem createMenuItem(item.title, 'goToUrl:')
    }
    @status_menu.addItem(NSMenuItem.separatorItem())
    @status_menu.addItem createMenuItem("Frontpage", 'goToHomepage')
    @status_menu.addItem createMenuItem("Quit", 'terminate:')
    @status_item.setHighlightMode(true)
    @status_item.setMenu(@status_menu)
  end

  def goToUrl(obj)
    @feedItems.each { |item|
      NSLog("%@", item.title)
      if (item.title == obj.title)
        NSLog("SELECTED #{item.guid}")
        goUrl = NSURL.alloc.initWithString(item.guid)
        @workspace.openURL goUrl
      end
    }
  end
# Delegate method
  def when_parser_initializes
    p "The parser is ready!"
  end

  def when_parser_parses
    p "The parser started parsing the document"
  end

  def when_parser_is_done
    if @feedCallback.respond_to? 'call'
      @feedCallback.call @feedItems
    end
  end

  def when_parser_errors
    p "The parser encountered an error"
    ns_error = feed_parser.parserError
    p ns_error.localizedDescription
  end
end