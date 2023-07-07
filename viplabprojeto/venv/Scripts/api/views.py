import os

from django.views.decorators.csrf import csrf_exempt

from static.yolov5.source.functions import detectionstrabism

from django.http import HttpResponse
from django.http import JsonResponse

import requests
import shutil
import subprocess
import json
import time
import csv

from urllib.parse import urlparse, parse_qs



video_data = []

@csrf_exempt
def remove_video(client_ip):
    for video in video_data:
        if video['client_ip'] == client_ip:
            video_name = video['video_name']
            video_path = os.path.join('input', video_name)
            if os.path.exists(video_path):
                os.remove(video_path)
            video_data.remove(video)

            return True
    return False

def submit_link(request):
    if request.method == 'POST':
        path_current = os.getcwd()
        path_input = os.path.join(path_current, 'input')
        path_output = os.path.join(path_current, 'output')

        if not os.path.isdir(os.path.join(path_current, "input")):
            os.mkdir(os.path.join(path_current, "input"))
            path_input = os.path.join(path_current, "input")
            print("Diretório de entrada foi criado, insira os vídeos no diretório de entrada.")

        if not os.path.isdir(os.path.join(path_current, "output")):
            os.mkdir(os.path.join(path_current, "output"))
            path_output = os.path.join(path_current, "output")
            print("Diretório de saída foi criado.")

        request_body = request.body.decode()
        params = json.loads(request_body)
        link = params["link"]
        token = params["token"]
        print("token = ", token)
        saveVideo_path = 'C:/Users/Cliente/Documents/GitHub/viplabApp/viplabprojeto/venv/scripts/input'

        parsed_url = urlparse(link)
        parsed_query = parse_qs(parsed_url.query)
        # filename = token # criando token para cada video (mudar)
        filename = '20140106_155822' #testando com video sem gra var
        file_path = os.path.join(saveVideo_path, filename + ".mp4")

        response = requests.get(link)

        # salvar video na pasta (mdar)
        # with open(file_path, "wb") as f:
        #     f.write(response.content)

        response.close()
        video_path = 'input/' + filename +".mp4"

        video_data.append({
            'token': filename,
            'video_name': filename + ".mp4",
            'csv_path': 'output/' + filename + ".csv",

        })
        
        # subprocess.run(["python", "static/yolov5/source/strabismus_detection.py", filename]) (mudar)

        # if remove_video(client_ip):
        #     print(f"Vídeo associado ao cliente {client_ip} foi removido com sucesso.")
        # else:
        #     print(f"Não foi encontrado um vídeo associado ao cliente {client_ip}.")

        
        
        print(video_data)
        
        return HttpResponse(link, status=200)

# @csrf_exempt
# def submit_link(request):
#     if request.method == 'POST':
#         # link = request.POST.get('link')
#         #recupera o path atual de trabalho
#         path_current = os.getcwd()

#         #diretorio dos videos para serem processados
#         path_input = os.path.join(path_current,'input')

#         #diretorio principal de resultados
#         path_output = os.path.join(path_current,'output')

#         # verifica se o diretorio de entrada existe, senão existir cria
#         if not os.path.isdir(os.path.join(path_current,"input")):
#             os.mkdir(os.path.join(path_current,"input"))
#             path_input = os.path.join(path_current,"input")
#             print("Diretorio de entrada foi criado, insira os videos no diretorio de entrada.")

#         # #verifica se o diretorio de saída existe, senão existr cria
#         if not os.path.isdir(os.path.join(path_current,"output")):
#             os.mkdir(os.path.join(path_current,"output"))
#             path_output = os.path.join(path_current,"output")
#             print("Diretorio de saída foi criado.")
        
#         # pega o request como uma string
#         # link = request.body.decode() #temporario
#         request_body = request.body.decode()

#         # passa como um json object
#         params = json.loads(request_body)
#         link = params["link"]

#         # extraindo o link do firebase do json object
#         params = json.loads(request.body)
#         saveVideo_path = 'C:/Users/Cliente/Documents/GitHub/viplabApp/viplabprojeto/venv/scripts/input'
        
#         parsed_url = urlparse(link)
#         parsed_query = parse_qs(parsed_url.query) #transforma em dicionario de parametros (depois do ? > token)
#         filename = parsed_query['token'][0]

#         print(filename)
#         file_path = os.path.join(saveVideo_path, filename+".mp4") # setar nome do video como horario local // hash pra cada requisiçao

#         response = requests.get(link)
        
#         print(link)
#         # salvar video na pasta
#         # with open(file_path, "wb") as f:
#         #     f.write(response.content)
#             # response.raw.decode_content = True
#             # shutil.copyfileobj(response.raw, file)
        
#         response.close()
#         folder_path = "output"
#         # apagar arquivos na pasta de output
#         for filename in os.listdir(folder_path):
#                 file_path = os.path.join(folder_path, filename)
#                 if os.path.isfile(file_path):
                 
#                     os.remove(file_path)

#         subprocess.run(["python", "static/yolov5/source/strabismus_detection.py"])

      
#         return HttpResponse(link, status=200)


    elif request.method == 'GET':
        matching_video = None
        found = False

        token = request.META.get('HTTP_AUTHORIZATION')
        if token:
            _, token = token.split(None, 1)
            print(token)
        else:
            print('Algo ocorreu ou o token não foi criado com sucesso.')
        

        for video in video_data:
            # if video['token'] == token: (mudar)
            if token == token: # so pra passar
                matching_video = video
                # found = True
                #print("matching video virou video")
                break

        if matching_video:
            #print('entrou matching video')
            csv_path = os.path.join(os.getcwd(), matching_video['csv_path'])

            if os.path.exists(csv_path):
                with open(csv_path, newline='') as csvfile:
                    reader = csv.reader(csvfile)
                    data = [row for row in reader]

                header = data[0][0].split(";")
                values = data[1][0].split(";")
                result = {}

                for i in range(len(header)):
                    if header[i] not in ["File", "DEp"]:
                        result[header[i]] = values[i]

                print(result)
                print("o tamanho é no get " + str(len(video_data)))
            
                # video_data.remove(matching_video)
                # videoPathRemove = os.path.join('C:/Users/Cliente/Documents/GitHub/viplabApp/viplabprojeto/venv/scripts/input', matching_video['video_name'])
                # videoPathRemoveN = os.path.normpath(videoPathRemove)
                # os.remove(videoPathRemoveN)
                print("o tamanho é pos " + str(len(video_data)))

                return JsonResponse(result, safe=False)
            else:
                print("O arquivo de resultados não existe ou ainda não está pronto.")
                return HttpResponse(content='Algo de errado aconteceu.', status=405)
        else:
            print("Não foi encontrado nenhum vídeo correspondente ao cliente.")
            return HttpResponse(content='Algo de errado aconteceu.', status=405)

    # elif request.method == 'GET':
    #     if os.path.exists('C:/Users/Cliente/Documents/GitHub/viplabApp/viplabprojeto/venv/scripts/output/results.csv') == True:
    #         # with open('C:/Users/Cliente/Documents/GitHub/viplabApp/viplabprojeto/venv/scripts/output/'+ filename +'.csv', newline='') as csvfile:
    #         with open('C:/Users/Cliente/Documents/GitHub/viplabApp/viplabprojeto/venv/scripts/output/results.csv', newline='') as csvfile:
    #             reader = csv.reader(csvfile)
    #             data = [row for row in reader]

    #         # print(data)
            
    #         # csv pra json
    #         print(data[0][0])
    #         print(data[1][0])
            
    #         # Separa as informações do cabeçalho
    #         header = data[0][0].split(";")

    #         # Separa as informações dos valores
    #         values = data[1][0].split(";")

    #         # Cria um dicionário para associar as informações do cabeçalho com as informações dos valores
    #         result = {}
    #         for i in range(len(header)):
    #             if header[i] not in ["File", "DEp"]:
    #                 result[header[i]] = values[i]

    #         print(result)
    #         # response_data = json.dumps(result)
            


            
    #         return JsonResponse(result, safe=False)
            
    #     else:
    #         print("O arquivo de resultados não existe ou ainda não está pronto.")
    #         return HttpResponse(content='Algo de errado aconteceu.', status=405)
    # else:
    #     return HttpResponse(content='algo deu errado com o request, metodo errado', status=405)

    # if request.headers.get('Content-Type') != 'application/json':
    #     return HttpResponse('Tipo de conteúdo inválido', status=400)
    # if not request.body:
    #     return HttpResponse('Empty request body', status=400)
    # try:
    #     json_data = json.loads(request.body)
    # except json.decoder.JSONDecodeError:
    #     return HttpResponse('JSON inválido', status=400)

    # # json_data = json.loads(request.body)
    # link = json_data.get('link','')
    # # Do something with the link
    # return HttpResponse("Link received: " + link)

      # # processar cada frame do video atual
        #     while cap.isOpened() and ret == True:


        #         #salva imagem original
        #         #save_image_step("original",frame_count,next_frame)

        #         #Realiza a detecção dos olhos / futuramente oclusor

        #         image_resized = cv2.resize(current_frame, (416,416))
        #         h ,w , _ = image_resized.shape
        #         frame_name = name_aqr+"_Frame_"+str(frame_count)

        #         '''
        #         List of detections of objects for one frame
        #         detections_find type list of tuples (img,label_class,confidence,Pmin,Pmax)
        #         img = 640x640 pixels
        #         detections(obj1,obj2,...,objN)
        #         '''
        #         # detections_find = det.detect(frame_name,image_resized,path_output, path_input, _weights = "/home/robert/Documentos/pesquisa/yolov5/runs/exp3/weights/best.pt", _view_img = False, _img_size = h, _save_img = False, _conf_thres = 0.5)
        #         detections_find = det.detect(frame_name,image_resized,path_output, path_input, _weights = "C:/Users/Cliente/Documents/GitHub/viplabApp/viplabprojeto/venv/scripts/static/yolov5/runs/exp2/weights/best.pt", _view_img = False, _img_size = h, _save_img = True, _conf_thres = 0.7)
        #         #save_image_step(path_output,"detection_"+str(frame_count),detections_find[0][0])
        #         #para cada obejeto de interesse
        #         count_obj = 1
        #         for obj in detections_find:

        #             label_class = obj[1] #classe do objeto
        #             confidence = obj[2] #confiança da detecção para o objeto
        #             p_min = obj[3] #ponto minimo da região
        #             p_max = obj[4] # ponto max da região
        #             img_rs = obj[0] #imagem de retorno da rede

        #             #detecção do centro dos olhos  AINDA INCOMPLETO
        #             #detect_eyes_centers(img_rs,label_class,confidence,p_min,p_max)

        #             #desenha o centro do olho
        #             #cv2.circle(img, center=(960,650), radius=70, color=(0,0,255), thickness=10)
        #             if label_class == 'olho':
        #                 image_resized = cv2.rectangle(image_resized,p_min,p_max,(0,0,255),thickness=2)
        #                 largura = (p_max[0] - p_min[0]) // 2
        #                 altura = (p_max[1] - p_min[1]) // 2

        #                 centerCoord = (p_min[0]+largura,p_min[1]+altura)

        #                 image_resized = cv2.circle(image_resized,centerCoord,3,(255,0,0),-1)
        #             else:
        #                 image_resized = cv2.rectangle(image_resized,p_min,p_max,(0,255,0),thickness=2)
        #             # cv2.imshow("image_resized", image_resized)
        #             # cv2.waitKey(0)
        #             # cv2.destroyAllWindows()
        #             pause = 0
        #             count_obj+=1

        #         #escreve a imagem no video de saida
        #         out.write(image_resized)

        #         current_frame = next_frame #proximo frame vira o atual
        #         ret, next_frame = cap.read() #recupera o proximo frame
        #         frame_count = frame_count + 1

        #     cap.release()
        #     out.release()

        # # detections_find = det.detect(frame_name,current_frame,path_output, path_input, _weights ='C:/Users/Cliente/Documents/GitHub/viplabApp/viplabprojeto/venv/scripts/static/yolov5/runs/exp2/weights/best.pt', _view_img =False, _img_size = h, _save_img = False, _conf_thres = 0.7)
