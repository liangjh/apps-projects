import uuid
from PIL import Image, ImageDraw, ImageFont 
from flask import current_app


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
    font_ttf_loc    = '{app_root}/{data_dir}{font_file}'.format(app_root=current_app.root_path, 
                                                                data_dir=data_dir, font_file=params['font_ttf_loc'])
    font_size_title = params['font_size_title']
    font_size_body  = params['font_size_body']
    text_start_y_px = params['text_start_y_px']
    text_gap_y_px   = params['text_gap_y_px']
    base_gap_px     = params['base_gap_px']
    final_image_width = params['final_image_width']
    signature         = '{} {}'.format(params['signature'], params['signature_url'])

    # from image + calculated
    signaturergb    = (255,255,255)
    signature_offset_px = 20
    font_size_signature = 20
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

    # Construct Quote Canvas
    # Initialize quote image length, based on size of textb
    quoteimg_len = margin_px + text_start_y_px + text_gap_y_px * len(quotelines) + signature_offset_px
    quoteimg = Image.new('RGB', (image_width_px, quoteimg_len), color=imgbgrgb)

    # Title may be null, so adjust accordingly
    if title is not None:
        #  Write title (+ centering)
        dtitle = ImageDraw.Draw(quoteimg)
        txt_len_px = dtitle.textsize(title, font=ImageFont.truetype(font_ttf_loc, font_size_title))[0]
        dtitle.text((image_width_px / 2 - txt_len_px / 2, base_gap_px),  # (x,y) positioning, calculated
                    title, fill=textrgb, font=ImageFont.truetype(font_ttf_loc, font_size_title))

    #  Write content (+ centering via text size calculation / positioning)
    curr_y_pos = text_start_y_px
    for i,line in enumerate(quotelines):
        dquote = ImageDraw.Draw(quoteimg)    
        txt_len_px = dquote.textsize(line, font=ImageFont.truetype(font_ttf_loc, font_size_body))[0]
        dquote.text((image_width_px / 2 - txt_len_px / 2, curr_y_pos), 
                    text=line, fill=textrgb, font=ImageFont.truetype(font_ttf_loc, font_size_body))
        curr_y_pos += text_gap_y_px
    
    #  Write signature (+ centering)
    #  Yes, there is duplication here, but easier to debug
    dsign = ImageDraw.Draw(quoteimg)
    txt_len_px = dsign.textsize(signature, font=ImageFont.truetype(font_ttf_loc, font_size_signature))[0]
    dsign.text((image_width_px / 2 - txt_len_px / 2, curr_y_pos + signature_offset_px),
               signature, fill=signaturergb, font=ImageFont.truetype(font_ttf_loc, font_size_signature))

    #  Assemble Final Canvas (image + quote image)
    #  Create final canvas image
    canvas_width  = img.size[0] + 2 * margin_px
    canvas_length = img.size[1] + quoteimg_len + 2 * margin_px
    merged_img = Image.new('RGB', (canvas_width, canvas_length), color=imgbgrgb)

    # Add image & text sections
    merged_img.paste(img, (margin_px, margin_px))
    merged_img.paste(quoteimg, (margin_px, margin_px + img.size[1]))

    # Narrow to correct final image size based on proportional size ratio
    size_ratio = merged_img.size[0] / final_image_width
    merged_img = merged_img.resize((int(size_ratio * merged_img.size[0]), int(size_ratio * merged_img.size[1])), Image.ANTIALIAS)

    return merged_img



