# mypmmoda
This algorithm is part of the pyDAMPF project and has been developed as a joint project between the IJS and UMSA. This software will enable students and researchers from the AFM community to easily plan AFM experiments.

pyDAMPF is a tool oriented to the Atomic Force Microscopy (AFM) community, which allows the simulation of the physical properties of materials under variable relative humidity (RH) using an engine written in Fortran (mypmmoda). In particular, pyDAMPF is mainly focused on the mechanical properties of polymeric hygroscopic nanofibers that play an essential role in designing tissue scaffolds for implants and filtering devices.

An introduction to pyDAMPF in the context of evaluating maximum exerted forces by a cantilever Tip under variable environments is in the following [SciPy 2022 paper](https://conference.scipy.org/proceedings/scipy2022/pyDAMPF_HVGuzman.html).

Check out the [official repo](https://github.com/govarguz/pyDAMPF) for this algorithm execution environment.

## Input
|param|type|description|required|
|-----|----|-----------|--------|
|`function_name`|string|The function of the module for the algorithm execution (`mypmmoda_MOD_mainbim`)|Yes|
|`naux`|integer|Number of periods times points per period|Yes|
|`/inputs.ini`|file|A file describing the simulation parameters|Yes|

## Output
|param|type|
|-----|----|
|`/zcdom.dfo`|file|
|`/tdom.dfo`|file|


## Driver example

```python
import asyncio
from motivus.client import Client

async def motivus_task(naux):
    motivus = await Client.connect()

    task_definition = {
        'algorithm': "mypmmoda",
        'algorithm_version': "0.1.0",
        'params': ['mypmmoda_MOD_mainbim', naux],
        'preload_files': {
            '/inputs.ini': motivus.read_file("./inputs.ini")
        },
        'result_files': {
            '/zcdom.dfo': './zcdom.dfo',
            '/tdom.dfo': './tdom.dfo'
        }
    }

    task_id = motivus.call_async(task_definition)
    task = motivus.select_task(task_id)
    return await task

class mypmmoda(object):
    @classmethod
    def mainbim(cls, naux):
        asyncio.run(motivus_task(naux))

mypmmoda.mainbim(128000)
```
