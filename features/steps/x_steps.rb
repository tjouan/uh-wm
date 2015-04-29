Given /^an ICCCM compliant window is mapped$/ do
  icccm_window_start
  timeout_until 'window not mapped after %d seconds' do
    x_window_map_state(icccm_window_name) == 'IsViewable'
  end
end

Given /^a(?:\s(\w+))? window is mapped$/ do |ident|
  x_client(ident).map.sync
  timeout_until 'window not mapped after %d seconds' do
    x_window_map_state(x_client(ident).window_id) == 'IsViewable'
  end
end

When /^I press the ([^ ]+) keys?$/ do |keys|
  x_key keys
end

When /^I press the ([^ ]+) keys? (\d+) times$/ do |keys, times|
  times.to_i.times { x_key keys }
end

When /^I quickly press the ([^ ]+) keys? (\d+) times$/ do |keys, times|
  x_key [keys] * times.to_i, delay: 0
end

When /^a window requests to be mapped$/ do
  x_client.map.sync
end

When /^a window requests to be mapped (\d+) times$/ do |times|
  x_client.map times: times.to_i
end

When /^the(?:\s(\w+))? window is unmapped$/ do |ident|
  x_client(ident).unmap.sync
  timeout_until 'window not unmapped after %d seconds' do
    x_window_map_state(x_client(ident).window_id) == 'IsUnMapped'
  end
end

When /^the window is destroyed$/ do
  x_client.destroy.sync
end

When /^the window name changes to "([^"]+)"$/ do |name|
  x_client.window_name = name
end

Then /^the(?:\s(\w+))? window must be mapped$/ do |ident|
  timeout_until 'window not mapped after %d seconds' do
    x_window_map_state(x_client(ident).window_id) == 'IsViewable'
  end
end

Then /^the ICCCM window must be unmapped by the manager$/ do
  uhwm_wait_output /unmanag.+#{icccm_window_name}/i
end

Then /^the window must be focused$/ do
  timeout_until 'window not focused after %d seconds' do
    x_focused_window_id == x_client.window_id
  end
end

Then /^the input event mask must include (.+)$/ do |mask|
  expect(x_input_event_masks).to include mask
end
