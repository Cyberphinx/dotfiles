return {
  'Pocco81/auto-save.nvim',
  config = function()
    require('auto-save').setup {
      enabled = true, -- Enable auto-saving
      execution_message = {
        enabled = true,
        message = function()
          return ('AutoSave: saved at ' .. vim.fn.strftime '%H:%M:%S')
        end,
        dim = 0.18,
        cleaning_interval = 1250,
      },
      trigger_events = {
        immediate_save = { 'BufLeave', 'FocusLost' },
        defer_save = { 'InsertLeave', 'TextChanged' },
        cancel_defered_save = { 'InsertEnter' },
      },
      condition = nil, -- No specific condition for saving
      write_all_buffers = false,
      noautocmd = false,
      lockmarks = false,
      debounce_delay = 1000, -- Save after 1 second of inactivity
      debug = false,
    }
  end,
}
