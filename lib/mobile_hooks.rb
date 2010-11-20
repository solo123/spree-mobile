class MobileHooks < Spree::ThemeSupport::HookListener
  # custom hooks go here
  insert_after :admin_tabs do
    %(<%= tab(:quotes) %>)
  end
end