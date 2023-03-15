(function ($) {
	$.fn.connect = function (param) {
		var _canvas;
		var _ctx;
		var _lines = new Array(); //This array will store all lines (option)
		var _me = this;
		var _parent = param || document;
		var _lengthLines = $(_parent + ' .group1 .node').length;
		var _selectFirst = null;

		//Initialize Canvas object
		_canvas = $('<canvas/>')
			.attr('width', $('#layer-test').width())
			.attr('height', $('#layer-test').height())
			.css('position', 'absolute')
			.css('top', '0')
			.css('z-index', '1');
		$(_parent).prepend(_canvas);
		//$(_canvas).insertBefore(_parent);
		this.drawLine = function (option) {
			//It will push line to array.
			_lines.push(option);
			this.connect(option);
		};

		this.drawAllLine = function (option) {

			/*Mandatory Fields------------------
			left_selector = '.class',
			data_attribute = 'data-right',
			*/

			if (option.left_selector != '' && typeof option.left_selector !== 'undefined' && $(option.left_selector).length > 0) {
				$(option.left_selector).each(function (index) {
					var option2 = new Object();
					$.extend(option2, option);
					option2.left_node = $(this).attr('id');
					option2.right_node = $(this).data(option.data_attribute);
					if (option2.right_node != '' && typeof option2.right_node !== 'undefined') {
						_me.drawLine(option2);

					}
				});
			}
		};

		//This Function is used to connect two different div with a dotted line.
		this.connect = function (option) {

			_ctx = _canvas[0].getContext('2d');
			//
			_ctx.beginPath();
			try {
				var _color;
				var _dash;
				var _left = new Object(); //This will store _left elements offset  
				var _right = new Object(); //This will store _right elements offset   
				var _error = (option.error == 'show') || false;

				/*
				option = {
					left_node - Left Element by ID - Mandatory
					right_node - Right Element ID - Mandatory
					status - accepted, rejected, modified, (none) - Optional
					style - (dashed), solid, dotted - Optional   
					horizantal_gap - (0), Horizantal Gap from original point
					error - show, (hide) - To show error or not
					width - (2) - Width of the line
				}
				*/

				if (option.left_node != '' && typeof option.left_node !== 'undefined' && option.right_node != '' && typeof option.right_node !== 'undefined' && $(option.left_node).length > 0 && $(option.right_node).length > 0) {

					//To decide colour of the line
					switch (option.status) {
						case 'accepted':
							_color = '#1744AE';
							break;

						case 'rejected':
							_color = '#e7005d';
							break;

						case 'modified':
							_color = '#bfb230';
							break;

						case 'none':
							_color = 'grey';
							break;

						default:
							_color = 'grey';
							break;
					}

					//To decide style of the line. dotted or solid
					switch (option.style) {
						case 'dashed':
							_dash = [4, 2];
							break;

						case 'solid':
							_dash = [0, 0];
							break;

						case 'dotted':
							_dash = [4, 2];
							break;

						default:
							_dash = [4, 2];
							break;
					}
					/*
						console.log($(option.left_node));
						$(option.left_node)
						$(option.right_node).data('connect',true);
					*/
					//If left_node is actually right side, following code will switch elements.
					$(option.right_node).each(function (index, value) {
						_left_node = $(option.left_node);
						_right_node = $(value);

						_left_node.attr('data-connect', true);
						_right_node.attr('data-connect', true);
						_right_node.val(_left_node.val());

						if (_left_node.offset().left >= _right_node.offset().left) {
							_tmp = _left_node
							_left_node = _right_node
							_right_node = _tmp;
						}

						//Get Left point and Right Point
						_left.x = _left_node.offset().left + _left_node.outerWidth();
						_left.y = _left_node.offset().top + (_left_node.outerHeight() / 2);
						_right.x = _right_node.offset().left;
						_right.y = _right_node.offset().top + (_right_node.outerHeight() / 2);

						//Create a group
						//var g = _canvas.group({strokeWidth: 2, strokeDashArray:_dash});    

						//Draw Line
						var _gap = option.horizantal_gap || 0;

						_ctx.moveTo(_left.x, _left.y);
						if (_gap != 0) {
							_ctx.lineTo(_left.x + _gap, _left.y);
							_ctx.lineTo(_right.x - _gap, _right.y);
						}
						_ctx.lineTo(_right.x, _right.y);

						if (!_ctx.setLineDash) {
							_ctx.setLineDash = function () { }
						} else {
							_ctx.setLineDash(_dash);
						}
						_ctx.lineWidth = option.width || 2;
						_ctx.strokeStyle = _color;
						_ctx.stroke();
					});

					//option.resize = option.resize || false;
				} else {
					if (_error) alert('Mandatory Fields are missing or incorrect');
				}
			} catch (err) {
				if (_error) alert('Mandatory Fields are missing or incorrect');
			}
			//console.log(_canvas);
		};

		//It will redraw all line when screen resizes
		$(window).resize(function () {
			if ($('canvas').length > 0) {
				$('canvas').attr('width', $('body').width());
				$('canvas').attr('height', $('body').height());
				_me.redrawLines();
			}
		});

		$('.test-question').scroll(function () {
			if ($('canvas').length > 0) {
				$('canvas').attr('width', $('body').width());
				$('canvas').attr('height', $('body').height());
				_me.redrawLines();
			}
		});

		$(_parent + ' .group1 .node input').click(function () {
			//console.log($(this).attr('data-connect'));
			//[data-use="false"]
			_this = this;

			$('.group1 .node input[data-connect="false"]').prop('checked', false);
			$(this).prop('checked', true);

			if ($(_this).attr('data-connect') != 'true') {
				if ($(_this).attr('data-use') == 'false') {
					$(_parent + ' .group1 .node input').attr('data-use', 'false');
					$(_this).attr('data-use', 'true');
					_selectFirst = _this;
				} else {
					$(_this).attr('data-use', 'false');
					$(_this).attr('data-connect', 'false').prop('checked', false);
				}
			} else if ($(_this).attr('data-connect') == 'true') {
				//console.log($(this).attr('data-id'));
				//console.log(entry);
				_lines.forEach(function (entry, index) {
					if ($(_this).attr('data-id') == entry.id_left) {
						$(entry.left_node).attr('data-use', 'false').attr('data-connect', 'false').prop('checked', false);
						$(entry.right_node).attr('data-use', 'false').attr('data-connect', 'false').prop('checked', false);
						_lines.splice(index, 1);
					}
				});
				_me.redrawLines();
			}
		});

		$(_parent + ' .group2 .node input[data-use="false"]').click(function () {
			_this = this;
			if ($(_parent + ' .group1 .node input[data-use="true"]').length == 1 && _selectFirst != null) {
				if ($(this).attr('data-connect') != 'true') {
					_me.drawLine({
						id_left: $(_selectFirst).attr('data-id'),
						id_right: $(this).attr('data-id'),
						left_node: _selectFirst,
						right_node: this,
						horizantal_gap: 0,
						error: 'show',
						width: 2,
						status: 'accepted',
						style: 'solid'
					});
					$(_selectFirst).attr('data-use', 'false');
					$(_selectFirst).attr('data-connect', 'true');
					$(this).attr('data-use', 'false');
					$(this).attr('data-connect', 'true');
				}
			} else {
				if ($(this).attr('data-connect') != 'true') {
					$(this).prop('checked', false);
				} else if ($(this).attr('data-connect') == 'true') {
					_lines.forEach(function (entry, index) {
						if ($(_this).attr('data-id') == entry.id_right) {
							$(entry.left_node).attr('data-use', 'false').attr('data-connect', 'false').prop('checked', false);
							$(entry.right_node).attr('data-use', 'false').attr('data-connect', 'false').prop('checked', false);
							$(entry.right_node).val($(entry.left_node).val());
							_lines.splice(index, 1);
						}
					});
					_me.redrawLines();
				}
			}
		});

		$('.btn-canvas-reset').click(function () {
			$('.nodes input').attr('data-use', 'false').attr('data-connect', 'false').prop('checked', false);
			$('.group2 input').val('');
			_lines.splice(0, _lines.length);
			_me.redrawLines();
		});

		this.redrawLines = function () {
			if (_ctx) {
				_ctx.clearRect(0, 0, $('#layer-test').width(), $('#layer-test').height());
				_lines.forEach(function (entry) {
					entry.resize = true;
					_me.connect(entry);
				});
			}
		};
		return this;
	};
}(jQuery));