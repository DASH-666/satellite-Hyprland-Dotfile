hl.config({
	plugin = {
	    hyprexpo = {
	        columns = 3,
            gaps_in = 0,
	        gaps_out = 0,
	        bg_col = 0xffffffff,
	        workspace_method = "center current",
            skip_empty = 9,
	        max_workspace = 0,
	        gesture_distance = 200,
            cancel_key = "escape",
            show_cursor = 1,
	        show_pinned_windows = 0,
	    },
        dynamic_cursors = {
	        enabled = true,
	        mode = "tilt",
	        threshold = 2,
            rotate = {
	            length = 24,
	            offset = 0.0,
	        },
	        tilt = {
	            limit = 2000,
	            activation = "negative_quadratic",
	            window = 200,
                full = 60,
	        },
	        stretch = {
	            limit = 800,
	            activation = "negative_quadratic",
                window = 200,
	        },
	        shake = {
	            enabled = true,
	            threshold = 4.0,
                base = 1.0,
	            speed = 2.0,
	            influence = 0.0,
	            limit = 5.0,
	            timeout = 1000,
                effects = true,
	            ipc = false,
	        },
	        hyprcursor = {
                nearest = 1,
                enabled = true,
	            resolution = -1,
	            fallback = "clientside",
	        },
	    },
    },
})
