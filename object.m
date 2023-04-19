function object_detection_and_recognition_GUI
    % Create the main figure window
    f = figure('Visible', 'off', 'Position', [360, 500, 450, 360]);

    % Create UI controls
    hloadcamera = uicontrol('Style', 'pushbutton', 'String', 'Load Camera', ...
        'Position', [315, 280, 70, 25], 'Callback', @loadcamerabutton_Callback);
    hstopcamera = uicontrol('Style', 'pushbutton', 'String', 'Stop Camera', ...
        'Position', [315, 230, 70, 25], 'Callback', @stopcamerabutton_Callback, 'Enable', 'off');
    hcaptureimage = uicontrol('Style', 'pushbutton', 'String', 'Capture Image', ...
        'Position', [315, 180, 70, 25], 'Callback', @captureimagebutton_Callback, 'Enable', 'off');
    haxes = axes('Units', 'Pixels', 'Position', [50, 60, 200, 200]);
    htext = uicontrol('Style', 'text', 'String', 'Select a Camera to Detect and Recognize Objects', ...
        'Position', [50, 315, 300, 15]);

    % Initialize the UI
    align([hloadcamera, hstopcamera, hcaptureimage, htext], 'Center', 'None');

    % Make the UI visible
    f.Visible = 'on';

    % Load camera button callback function
    function loadcamerabutton_Callback(source, eventdata)
        cam = webcam;
        net = alexnet;
        set(hloadcamera, 'Enable', 'off');
        set(hstopcamera, 'Enable', 'on');
        set(hcaptureimage, 'Enable', 'on');
        while ishandle(f)
            img = snapshot(cam);
            imshow(img, 'Parent', haxes);
            drawnow;

            % Perform object detection and recognition using AlexNet
            img = imresize(img, [227 227]);
            label = classify(net, img);
            title(haxes, char(label));
        end
        clear cam;

        htext.String = 'Camera Stopped';
        set(hloadcamera, 'Enable', 'on');
        set(hstopcamera, 'Enable', 'off');
        set(hcaptureimage, 'Enable', 'off');
    end

    % Stop camera button callback function
    function stopcamerabutton_Callback(source, eventdata)
        close(f);
    end

    % Capture image button callback function
    function captureimagebutton_Callback(source, eventdata)
        % Get the current snapshot from the camera
        img = snapshot(cam);

        % Save the image as a JPEG file
        imwrite(img, sprintf('image_%s.jpg', datestr(now, 'yyyymmdd_HHMMSS')));

        % Update the text label
        htext.String = 'Image Captured and Saved';
    end
end
