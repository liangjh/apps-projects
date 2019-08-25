import uuid
from PIL import Image, ImageDraw, ImageFont 


def make_poster(img: Image, params: dict, data_dir: str,
                title: str, quote: str) -> Image:
    '''
    Creates an inspirational poster (a la 90's style)
    from an inspiration image, title and text/body
    Parameters:
        img (PIL.Image): image object (binary)
        params (dict): poster creation parameters (all req'd below)
        data_dir (str): location of data (i.e. font file)
        title (str): title of poster
        quote (str): text of poster
    '''

    #  Retrieve configuration parameters 
    #  (break upfront if anything missing)
    imgbgrgb        = params['imgbgrgb']
    textrgb         = params['textrgb']
    margin_px       = params['margin_px']
    approx_char_px  = params['approx_char_px']
    font_ttf_loc    = '{}{}'.format(data_dir, params['font_ttf_loc'])
    font_size_title = params['font_size_title']
    font_size_body  = params['font_size_body']
    text_start_y_px = params['text_start_y_px']
    text_gap_y_px   = params['text_gap_y_px']
    base_gap_px     = params['base_gap_px']
    signature       = params['signature']

    # from image + calculated
    image_width_px  = img.size[0]
    text_width_px = image_width_px - (2 * margin_px)
    approx_chars_line = (text_width_px / approx_char_px)

    #  Construct quote lines
    #  Line Breaks / Separate Text Body
    #  Break the quote into individual lines to center later
    quotelines = []
    currtxt = ''
    for tok in quote.split():
        peektxt = ' '.join([currtxt, tok])
        if len(peektxt) > approx_chars_line:
            quotelines.append(currtxt)  #  line break
            currtxt = tok
            # print('wrapping: curr peek is at: {}'.format(str(len(peektxt))))
        else:
            currtxt = peektxt
    quotelines.append(currtxt)  # sweep in remainder
    quotelines.append(signature)  #  add signature (same font size)

    # Construct Quote Canvas
    # Initialize quote image length, based on size of textb
    quoteimg_len = margin_px + text_start_y_px + text_gap_y_px * len(quotelines)
    quoteimg = Image.new('RGB', (image_width_px, quoteimg_len), color=imgbgrgb)

    #  Write title (+ centering)
    dtitle = ImageDraw.Draw(quoteimg)
    txt_len_px = dtitle.textsize(title, font=ImageFont.truetype(font_ttf_loc, font_size_title))[0]
    dtitle.text((image_width_px / 2 - txt_len_px / 2, base_gap_px),  # (x,y) positioning, calculated
                title, fill=textrgb, font=ImageFont.truetype(font_ttf_loc, font_size_title))

    #  Write content (+ centering via text size calculation / positioning)
    curr_y_pos = text_start_y_px
    for line in quotelines:
        dquote = ImageDraw.Draw(quoteimg)    
        txt_len_px = dquote.textsize(line, font=ImageFont.truetype(font_ttf_loc, font_size_body))[0]
        dquote.text((image_width_px / 2 - txt_len_px / 2, curr_y_pos), 
                    line, fill=textrgb, font=ImageFont.truetype(font_ttf_loc, font_size_body))
        curr_y_pos += text_gap_y_px

    #  Assemble Final Canvas (image + quote image)
    #  Create final canvas image
    canvas_width  = img.size[0] + 2 * margin_px
    canvas_length = img.size[1] + quoteimg_len + 2 * margin_px
    merged_img = Image.new('RGB', (canvas_width, canvas_length), color=imgbgrgb)

    # Add image & text sections
    merged_img.paste(img, (margin_px, margin_px))
    merged_img.paste(quoteimg, (margin_px, margin_px + img.size[1]))

    return merged_img


def save_poster(img: Image, save_path: str, save_small: bool=True) -> dict:
    '''
    Given image, saves to save_path, and returns a dict with the GUID,
    large and small image names (saved to save path)

    Parameters:
        img
        save_path
        save_small
    '''

    # Generate GUID for this file
    guid = uuid.uuid4().hex

    # Save images
    # Save @ lower quality (high quality not necessary)
    img_width  = img.size[0]
    img_height = img.size[1]

    img_file_lg = '{}-lg.jpg'.format(guid)
    img_file_sm = '{}-sm.jpg'.format(guid)
    img.save('{}{}'.format(save_path, img_file_lg), optimize=True, quality=45)
    
    if save_small:
        img.resize((int(img_width / 2), int(img_height / 2)), Image.ANTIALIAS)\
           .save('{}{}'.format(save_path, img_file_sm), optimize=True, quality=35)
    
    return {
        'guid': guid,
        'img_file_lg': img_file_lg,
        'img_file_sm': img_file_sm
    }



