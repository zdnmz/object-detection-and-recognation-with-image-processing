function object_detection_and_recognition_GUI
    % Create the main figure window
    f = figure('Visible', 'off', 'Position', [360, 500, 450, 360]);

    % Create UI controls
    hloadcamera = uicontrol('Style', 'pushbutton', 'String', 'Load Camera', ...
        'Position', [315, 280, 70, 25], 'Callback', @loadcamerabutton_Callback);
    hstopcamera = uicontrol('Style', 'pushbutton', 'String', 'Stop Camera', ...
        'Position', [315, 230, 70, 25], 'Callback', @stopcamerabutton_Callback, 'Enable', 'off');
  
    haxes = axes('Units', 'Pixels', 'Position', [50, 60, 200, 200]);
    htext = uicontrol('Style', 'text', 'String', 'Select a Camera to Detect and Recognize Objects', ...
        'Position', [50, 315, 300, 15]);

    % Initialize the UI
    align([hloadcamera, hstopcamera, htext], 'Center', 'None');

    % Make the UI visible
    f.Visible = 'on';

    % Load camera button callback function
    function loadcamerabutton_Callback(source, eventdata)
    cam = webcam;
    pause(3); % Wait for 3 seconds

    net = alexnet;
    set(hloadcamera, 'Enable', 'off');
    set(hstopcamera, 'Enable', 'on');

    img = snapshot(cam);
    
    imshow(img, 'Parent', haxes);
    drawnow;

    % Perform object detection and recognition using AlexNet
    img = imresize(img, [227 227]);
    label = classify(net, img);
    title(haxes, char(label));

    clear cam;

    htext.String = 'Camera Stopped';
    set(hloadcamera, 'Enable', 'on');
    set(hstopcamera, 'Enable', 'on');
end

    % Stop camera button callback function
    function stopcamerabutton_Callback(source, eventdata)
        close(f);
    end

end
