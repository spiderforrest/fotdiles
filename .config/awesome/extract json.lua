
stdout = [[ {"full_text": "Am I a Girl? Am I a Boy? Do I Really Care?", "instance": " 0", "name": "spotify", "color": "#96BF33"},{"full_text": "41\u00b0C, 510.0 MiB", "color": "#96BF33", "instance": " 0", "name": "nvidia_smi", "separator": false, "separator_block_width": 0},{"full_text": " @ ", "color": "#A9A9A9", "instance": " 1", "name": "nvidia_smi", "separator": false, "separator_block_width": 0},{"full_text": "8.3%", "color": "#96BF33", "instance": " 2", "name": "nvidia_smi"},{"name": "ethernet", "instance": "_first_", "color": "#96BF33", "markup": "none", "full_text": "local: 192.168.0.17"},{"full_text": "live", "instance": "mic 0", "name": "volume_status", "color": "#F0FF47"},{"full_text": "40", "instance": "master 0", "name": "volume_status", "color": "#00FF00"},{"name": "disk", "instance": "/", "markup": "none", "full_text": "95.0 GiB"},{"name": "load", "markup": "none", "full_text": "load: 1.10", "instance": ""},{"name": "memory", "markup": "none", "full_text": "4.0 GiB of 11.2 GiB", "instance": ""},{"full_text": "async_script", "color": "#E89393", "instance": "_anon_module_0", "name": "async_script"} ]]

for module_str in string.gmatch(stdout, "{.-}") do
   print("module", module_str)
    for key, val in string.gmatch(module_str, '"(.-)": "(.-)"') do
       print("key", key)
       print("val", val)
    end
       print()
end
