# Check if the session is interactive and not an SSH session
# if status is-interactive
#     if not set -q SSH_CONNECTION
#         # Configure auto-attach/exit to your likings (default is off).
#         set ZELLIJ_AUTO_ATTACH true
#         set ZELLIJ_AUTO_EXIT true

#         # Check if not already inside a Zellij session
#         if not set -q ZELLIJ
#             # Generate auto-start script for Fish shell
#             eval (zellij setup --generate-auto-start fish | string collect)

#             # Attach to Zellij session if auto-attach is enabled
#             if test "$ZELLIJ_AUTO_ATTACH" = true
#                 zellij attach -c
#             else
#                 zellij
#             end

#             # Exit Fish shell if auto-exit is enabled
#             if test "$ZELLIJ_AUTO_EXIT" = true
#                 kill $fish_pid
#             end
#         end
#     end
# end
