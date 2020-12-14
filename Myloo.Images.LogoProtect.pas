unit Myloo.Images.LogoProtect;

interface

uses
  System.SysUtils,
  Vcl.Graphics,
  Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg,
  Myloo.Imaging;

type
  TIMGs = class
    // image keys 48x48 Bitmap
    class Function Img01:TBitmap;
    // image keys 48x48 PNG
    class Function Img02:TPNGImage;
  end;

implementation

{ TIMGs }

class Function TIMGs.Img01: TBitmap;
var
  Img:TStringBuilder;
begin
  Img := TStringBuilder.Create;
  Img.Append('Qk0GEgAAAAAAADYAAAAoAAAAKAAAACYAAAABABgAAAAAANARAADkDgAA5A4AAAAAAAAAAAAA');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/TU1NTU1N/wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/TU1N09PTzMzMTU1N');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/TU1NTU1N/wD//wD/');
  Img.Append('TU1N2tra09PTra2txcXFTU1N/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('TU1N4+Pj19fXTU1NTU1N4eHh2tra09PTra2txcXFTU1N/wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD/gICA8fHx4+Pjra2ty8vLTU1NTU1N2tra09PTra2txcXFTU1N/wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD/ubq7gICA8fHx4+Pjra2ty8vLgICA0NDQgICA09PTra2txcXF');
  Img.Append('TU1N/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/mavEP3O+PGKdPGKd/wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/gICA8fHx4+Pjra2ty8vLTU1NgICA');
  Img.Append('2tra09PTra2txcXFTU1N/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/QoPZjdH2iMz1');
  Img.Append('f8X0PGKd/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/TU1N4+Pj');
  Img.Append('ra2ty8vLTU1N4eHh2tra09PTra2txcXFTU1N/wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD/WKPpiMz1gsf0fMPzPGKd/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD/gICA8fHx4+Pjra2ty8vLgICATU1N2tra09PTra2txcXFTU1N/wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD/mavEQoPZWKPphcr1hcr1RYandr7yOlOC/wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD/gICA////8fHx4+Pjra2ty8vLgICA0NDQgICA09PTra2txcXFTU1N/wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD/QoPZjdH2jdH2hcr1RYanecDzcLnyOlOC/wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD/gICA8fHx4+Pjra2ty8vLgICATU1N2tra09PT');
  Img.Append('ra2txcXFTU1N/wD//wD//wD//wD//wD//wD//wD/WKPpjdH2iMz1RYanecDzc7zyOlOC/wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/TU1N4+Pjra2ty8vL');
  Img.Append('TU1N4eHh2tra09PTra2txcXFTU1N/wD//wD//wD/mavEQoPZQoPZWKPpkNP2iMz1RYanfMPz');
  Img.Append('c7zyOlOC/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/gICA');
  Img.Append('8fHx4+Pjra2ty8vLlZWVgICA2tra09PTra2txcXFTU1N/wD//wD//wD/QoPZnt75mdr4kNP2');
  Img.Append('i8/2RYanfMPzdr7yOlOC/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD/gICA////8fHx4+Pjra2ty8vLgICA4eHh2tra09PTzMzMxcXFTU1N/wD//wD//wD/');
  Img.Append('WKPpmdr4k9X3i8/2RYanf8X0dr7yOlOC/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD/gICA////8fHx4+Pjra2tgICA6Ojo4eHh2tra09PTzMzMxcXF');
  Img.Append('gICATU1N/wD/QoPZm9z4k9X3jdH2RYanf8X0ecDzOlOC/wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/gICA8fHx4+PjgICA8PDw6Ojo4eHh');
  Img.Append('2traQoPZQoPZQoPZQoPZQoPZQoPZm9z4ltf3kNP2RYangsf0fMPzOlOC/wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/gICA8fHxgICA');
  Img.Append('9/f38PDw6OjoQoPZQoPZu/X+uPL9su78rOn7pOP6nt75mdr4kNP2i8/2hcr1fMPzOlOC/wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('gICA1NTUgICA////9/f38PDwQoPZu/X+u/X+u/X+su78rOn7p+X6nt75mdr4k9X3i8/2hcr1');
  Img.Append('f8X0OlOC/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD/gICA39/f1NTUgICA////9/f3QoPZu/X+u/X+u/X+tfD9r+z8p+X6oeD5m9z4');
  Img.Append('k9X3jdH2iMz1gcf0OlOC/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD/gICA6enp39/f1NTUgICA////9/f3QoPZu/X+u/X+uPL9r+z8');
  Img.Append('quf7pOP6m9z4ltf3kNP2iMz1fsT0e8LzOlOC/wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD/gICA9PT06enp39/f1NTUgICA////QoPZu/X+');
  Img.Append('u/X+uPL9su78rOn7pOP6nt75mdr4kNP2i8/2fsT0d7/zcbryOlOC/wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/gICA////9PT06enp39/f1NTU');
  Img.Append('gICA////QoPZu/X+u/X+su78rOn7p+X6nt75mdr4k9X3gcf0fsT0d7/zcbrya7XxOlOC/wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/gICA////');
  Img.Append('9PT06enp39/f1NTUycnJgICAQoPZu/X+tfD9r+z8p+X6oeD5m9z4k9X3gcf0e8LzdL3ybrjx');
  Img.Append('Z7PwZLDwOlOC/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD/gICA////9PT06enp39/f1NTUTU1NTU1NQoPZuPL9r+z8quf7LzxTLzxTLzxTgcf0');
  Img.Append('e8LzdL3ybrjxZ7PwYa7vW6nvOlOC/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD/gICA////9PT06enp39/fTU1NgICA/wD/QoPZsu78NUVJNUVJ');
  Img.Append('NUVJ/wD//wD/LzxTcbrya7XxZ7PwYa7vW6nvOlOC/wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/gICA////9PT06enp39/fTU1NgICA/wD/');
  Img.Append('QoPZNUVJgICAgICAgICAAAAA/wD/LzxTa7XxZLDwXqvvWabsWKPpOlOC/wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/gICA9PT06enp');
  Img.Append('39/fTU1NgICAgICANUVJQoPZgcf0LzxTLzxTgICALzxTLzxTZLDwXqvvWabsV6DmOlOC/wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD/gICA6enp39/f1NTUTU1NNUVJgICAwMDAQoPZgcf0LzxTLzxTLzxTYa7vW6nvWabs');
  Img.Append('V6DmOlOC/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD/gICA39/f1NTUycnJNUVJgICAwMDAgICAQoPZQoPZZ7Pw');
  Img.Append('Ya7vW6nvWKPpOlOCOlOC/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/gICAgICAgICANUVJgICAgICA');
  Img.Append('gICA/wD/gICAOlOCOlOCOlOCOlOC/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD/NUVJgICA/wD//wD//wD/gICANUVJ/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD/NUVJNUVJNUVJNUVJNUVJ/wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/ra2tgICAra2t/wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Img.Append('/wD//wD//wD//wD//wD//wD//wD//wD//wD//wD/');
  Result := TImgBase64.BitmapFromBase64(Img.ToString);
end;

class Function TIMGs.Img02: TPNGImage;
var
  Img:TStringBuilder;
begin
  Img := TStringBuilder.Create;
  Img.Append('iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1');
  Img.Append('wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAh0SURBVFiFzZhpcB');
  Img.Append('THFcf/3TM7s7Ozq1tIQtdKoAskECImRQS20cFpqHzAccUhlGMuOxT5kBiKQ4lVCamAwI6hApFsSBmHOCn');
  Img.Append('jOEmRVAISGGOIDDa3YxASEhJCCKHVubuanavzQWhBZ9AKXPl/2+5+b37b772u1w38n4s8Kcd7NhdmW0W6');
  Img.Append('jCP8YsM0IgzDtBMCg+N5FwWtUny+/YZFO7y2+IT7awXcszH/KUkS94MiNTlunBAXE0FkSYQkiTAME25PD');
  Img.Append('9o63KhtvKu0ujpBGbeN55XtPyg+oTxRwA+ef57zZHp2MYIVOZOTrBOcMaBkZPdd7h6cu3JDaW5pbzNUM3');
  Img.Append('/Nr45eeyKAu9ctEOVwHA1y2GYU5E6xCgI/Kvu6W82s8ly11wRbvObnRz5+7ID7iud/EBHqWJKfO1Wk9IF');
  Img.Append('LV3s3rtc1qU13XT2KogkAIImiGhMTKqUnxQqhIXb/2rutHTh2+rJbNYwZa7dWXH1sgGU/nbtasgq7lhTO');
  Img.Append('sFp4DgBgGCbOXKxWam81qzBRYkD7ELqtBQA4okURiqXgyPrk+Cjhm9NSrX1/6v5ONvNUSe7LydHFYoD2F');
  Img.Append('D9rJybZ8fSMSX44TTdw9ORFT1eX5ySveF5YUXK6e4BZO4Ct+zfk7qq7jUMdXd5Z857JliklSIqPJnUN90');
  Img.Append('LutLRvAvA6ANCxAFp0cW1MZIgYGR7sH1M1HW6vQgwT/xgCzq8VJae7VxYfWdDe5f6k8nyVv4JnZKdIJjP');
  Img.Append('X79+Q6xgzIGfhXkpNjhUfHpMlEYvyptsEkS9552eFa0eyJwBTifLCzcYWX3tH73Fol62IDA8xfby0eEyA');
  Img.Append('uzctiNQ0fUJMVOigObvNioVzcmy8xbK9dMu8V0bys7b4hJuZ7K1rtU2+vrEJCeNkUbQsGxOgBXpqkF3q4');
  Img.Append('ejQLnohp8uiyO0sK5q/ZiRfTCN/aWxuVft+h4c4wBgmjQmQUYyXbeKIp4DdZsWivOmyINA3yrbMXT3cum');
  Img.Append('6D1fh8uj9VHHYJum5EjwkQpmkTeP5/HlPyfUjRannj7aJ5qx7JNyEgYGxMgITjwnpU9ZHs5d6ctAsi/+Z');
  Img.Append('QkDaBpUiCxV/JqqqBUq47YMC9m/JnE7CStORY26PayDYrFuZNtwsC/2bZ5nkrH57jCF0SPz7SH+JujwJK');
  Img.Append('cCtgQFEU9uRMTuadceNGZSdLIhbmT7eLVv7XpUXzVwDA7uIFQZSyH6dPHO8HvN3sUlRD/yhgQNM0x4WHO');
  Img.Append('gIx9UNKIvdWadH8FTbgTxOcMUKQozcYjDHUNtz1EY37e8CAhJL3r1Q1qKbJAoZckDfdbhXprpAg2+wZUy');
  Img.Append('dKfXM19XdNXdevvLL9yKWAARVVPXinpZ0/9flV3C+2gCCfy39KLpydbaf3z1JFUfHF5Wqvpms/6Vs3asD');
  Img.Append('SLYXfsFD+05ysZOJVfDh9ripQRkhWATzXi2AYJo6cvNita2zHq788fjYgwNJN+ZMIIRVTJzmtmakJJD83');
  Img.Append('C93dXvz73LWAIYHeBqPi1GW32+OrbLbM3Prw3CP3g2Wb5qYTCyqnpDuDstITKRjQ0e6Cqmq4cL0ZDlnCz');
  Img.Append('Jw0jNTlf9Wl4WyHgRq3CY9uggAQKWBzd+pyV9txQ2leVFx8Qh814N6iOWkcsXw2Nd0ZlJWRSBmAjtZ7YI');
  Img.Append('whNCIShslw7NQlOOwSZuakD4Js6jFwoEGFGxySYxMQExYBURAAAIrqw502F6tqaPAoulprqOaLB1Zv/88');
  Img.Append('jA5YWFaZQQs9kZSQGT0kfDEfu0+iajvLTlxEdGYqpGU70dcmf3e7AH+9RNnViGkmNT/CvHyjGGK7dqjcv');
  Img.Append('3qjuYTqee3fVthMAwI0Et2fjvIk8T85kZSSG9IczERoxrt/HKEdhmKz7/Jc3uBZXhxYe4uCvtnSyg20Wz');
  Img.Append('M7OIc7o8cPCAQAhBJHBISQ8KFi41dqyNGvhrD9fOnzKNSzg3o0FyYKFnMlKTwydkuEcEQ4AquuaOs9euK');
  Img.Append('4zgz6jqL7OmpvNccf4KDEzLdPijIoZRFaYmIcJIUmo7azrN+6w2WDhLHxrZ3vu+b99+vaQd5Lfbpzv5AR');
  Img.Append('2JjMtYVi4Ax/2ux325p2Bgh9uK78A4NyydzZ8HGSTPkqJjRv1xSw1Lo5+1VCXtvx3rxUMAvzNlrxEnmNf');
  Img.Append('ZKbHh01Jd5JeuBYwhkE7Z+gkdl1JedNQH5F4y6qMRKc8UliHEyEEGfGJ8uXaGy/3OwfLivImCNRyIXuyM');
  Img.Append('2xKetIAuMgRc2igGGGzokPDA77WRoeFERD2tH8H924sSCaE+3xapjNkUkoCeRDW0cMBgGEaYTbR6v9dmJ');
  Img.Append('g35LqB4+X1xwEAdkmCrhsRfkBe4HdOTBw3AI4NCVdVe7uTgJjMxg/7MsUYCSS6g8QDQHHxszzTzbkpSbE');
  Img.Append('EANwdHTBMA2GRQxdEbz9O8n5U/M+uYR1z1OVRlJhgWQbwYGf61LdzA8f75OlRwFHOxQNAhCZ8SxB5Gnb/');
  Img.Append('rUR2BEGmQaDkQYqOVBBDySSsosl173vBshxQx9ToumcCrJwCgEDo0qSEKEvfJOVoP7hApKrG76tuNXgD6');
  Img.Append('RlNk+F6Y4NXY9pBCgCEsm9HRYSM6Z1moA6uKilXdb26qrHeHK3ttcabpqYaVe+9vLOCAoBpGH+oPF/ldX');
  Img.Append('v7P3L6VA1fVtUbHCUdIxXEcFJ07buXamq8Ta7WQXPl9ceHzL8mVysu19zwqpr5IvBQs1C2ee7rgpVb/8z');
  Img.Append('MLLnV1aneqL/b3dntkTlKP1GYsX7dLyqujBYQAJbv3zCHo9zhaRNTpLS4BDraZqHf6rKiglcJpRuZyQ7p');
  Img.Append('jP018npo5XcOHTICAXtY39/3WqaFE98XBT4pIz5Rjg4PJw6p95Lk9nrR1NZqVjU0eANqtx6nXtq3fj7l+');
  Img.Append('eVgyNdNMwwALJRzMcKOm7r+3rsrd/xroM1/ARqcoum99mGFAAAAAElFTkSuQmCC');
  Result := TImgBase64.PngFromBase64(Img.ToString);
end;

end.
