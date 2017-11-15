import cv2

def render_gazes_on_image(frame, outputs, window_width, window_height, window_width_cm, window_height_cm, camera_h_from_screen_top):
    screen_start_from_camera_x = -window_width_cm / 2.0
    screen_start_from_camera_y = -camera_h_from_screen_top * 1.0

    print(outputs)

    for output in outputs:
        screen_x_in_cm = output[0]- screen_start_from_camera_x
        screen_y_in_cm = screen_start_from_camera_y - output[1]


        screen_x = screen_x_in_cm * window_width / window_width_cm
        screen_y = screen_y_in_cm * window_height / window_height_cm
        print("in cm:", screen_x_in_cm, screen_y_in_cm)
        print("in px:", round(screen_x), round(screen_y))

        if screen_x_in_cm >= 0 and screen_y_in_cm >= 0:

            cv2.circle(frame, (20, 20), 5, (0, 0, 255), -1)
            cv2.circle(frame, (int(round(screen_x)),int(round(screen_y))), 20, (0, 0, 255), -1)
